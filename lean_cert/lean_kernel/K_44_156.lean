import Sound
import lean_certs.cert_44_156

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_156_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 156 := by
  exact certValidRoot_sound (k := 44) (d := 156) (c := cert_44_156) (by decide)
