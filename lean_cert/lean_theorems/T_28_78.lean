import Sound
import lean_certs.cert_28_78

open CertVerify

theorem H28_gt_78 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 28) (d := 78) (c := cert_28_78) (by native_decide)
