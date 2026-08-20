import Sound
import lean_certs.cert_30_78

open CertVerify

theorem H30_gt_78 : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 30) (d := 78) (c := cert_30_78) (by native_decide)
