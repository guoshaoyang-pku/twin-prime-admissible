import Sound
import lean_certs.cert_50_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_156_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 50) (d := 156) (c := cert_50_156) (by decide)
