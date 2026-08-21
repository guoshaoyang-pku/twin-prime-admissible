import Sound
import lean_certs.cert_46_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H46_gt_156_kernel : ¬ ∃ t : List Nat, admissible 46 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 46) (d := 156) (c := cert_46_156) (by decide)
