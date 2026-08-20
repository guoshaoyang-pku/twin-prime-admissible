import Sound
import lean_certs.cert_31_78

open CertVerify

theorem H31_gt_78 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 31) (d := 78) (c := cert_31_78) (by native_decide)
