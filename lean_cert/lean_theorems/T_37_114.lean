import Sound
import lean_certs.cert_37_114

open CertVerify

theorem H37_gt_114 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 114 := by
  exact certValidRoot_sound (k := 37) (d := 114) (c := cert_37_114) (by native_decide)
