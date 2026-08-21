import Sound
import lean_certs.cert_38_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H38_gt_156_kernel : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 38) (d := 156) (c := cert_38_156) (by decide)
