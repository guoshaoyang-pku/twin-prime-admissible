import Sound
import lean_certs.cert_45_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H45_gt_156_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 45) (d := 156) (c := cert_45_156) (by decide)
