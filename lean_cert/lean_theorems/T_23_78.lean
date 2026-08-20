import Sound
import lean_certs.cert_23_78

open CertVerify

theorem H23_gt_78 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 23) (d := 78) (c := cert_23_78) (by native_decide)
