import Sound
import lean_certs.cert_50_230

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_230_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 230 := by
  exact certValidRoot_sound (k := 50) (d := 230) (c := cert_50_230) (by decide)
