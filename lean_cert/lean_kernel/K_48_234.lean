import Sound
import lean_certs.cert_48_234

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H48_gt_234_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 234 := by
  exact certValidRoot_sound (k := 48) (d := 234) (c := cert_48_234) (by decide)
