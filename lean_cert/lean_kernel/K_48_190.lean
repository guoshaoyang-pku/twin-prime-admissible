import Sound
import lean_certs.cert_48_190

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_190_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 190 := by
  exact certValidRoot_sound (k := 48) (d := 190) (c := cert_48_190) (by decide)
