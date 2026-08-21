import Sound
import lean_certs.cert_50_220

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_220_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 220 := by
  exact certValidRoot_sound (k := 50) (d := 220) (c := cert_50_220) (by decide)
