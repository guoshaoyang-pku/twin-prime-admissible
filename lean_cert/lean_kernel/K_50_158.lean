import Sound
import lean_certs.cert_50_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_158_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 50) (d := 158) (c := cert_50_158) (by decide)
