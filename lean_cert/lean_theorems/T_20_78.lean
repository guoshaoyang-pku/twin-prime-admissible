import Sound
import lean_certs.cert_20_78

open CertVerify

theorem H20_gt_78 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 20) (d := 78) (c := cert_20_78) (by native_decide)
