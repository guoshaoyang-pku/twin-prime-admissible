import Sound
import lean_certs.cert_27_114

open CertVerify

theorem H27_gt_114 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 27) (d := 114) (c := cert_27_114) (by native_decide)
