import Sound
import lean_certs.cert_50_234

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_234_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 234 := by
  exact certValidRoot_sound (k := 50) (d := 234) (c := cert_50_234) (by decide)
