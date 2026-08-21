import Sound
import lean_certs.cert_50_222

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_222_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 222 := by
  exact certValidRoot_sound (k := 50) (d := 222) (c := cert_50_222) (by decide)
