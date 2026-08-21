import Sound
import lean_certs.cert_18_52

open CertVerify

theorem H18_gt_52 : ¬ ∃ t : List Nat, admissible 18 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 18) (d := 52) (c := cert_18_52) (by native_decide)
