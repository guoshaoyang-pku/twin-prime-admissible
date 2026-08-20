import Sound
import lean_certs.cert_38_114

open CertVerify

theorem H38_gt_114 : ¬ ∃ t : List Nat, admissible 38 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 38) (d := 114) (c := cert_38_114) (by native_decide)
