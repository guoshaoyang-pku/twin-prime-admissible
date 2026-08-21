import Sound
import lean_certs.cert_48_188

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_188_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 48) (d := 188) (c := cert_48_188) (by decide)
