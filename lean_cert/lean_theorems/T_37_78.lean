import Sound
import lean_certs.cert_37_78

open CertVerify

theorem H37_gt_78 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 37) (d := 78) (c := cert_37_78) (by native_decide)
