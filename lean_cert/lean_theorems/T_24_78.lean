import Sound
import lean_certs.cert_24_78

open CertVerify

theorem H24_gt_78 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 78 := by
  exact certValidRoot_sound (k := 24) (d := 78) (c := cert_24_78) (by native_decide)
