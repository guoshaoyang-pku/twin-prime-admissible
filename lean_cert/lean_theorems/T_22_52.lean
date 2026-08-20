import Sound
import lean_certs.cert_22_52

open CertVerify

theorem H22_gt_52 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 22) (d := 52) (c := cert_22_52) (by native_decide)
