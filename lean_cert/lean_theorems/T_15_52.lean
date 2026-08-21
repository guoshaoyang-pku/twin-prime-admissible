import Sound
import lean_certs.cert_15_52

open CertVerify

theorem H15_gt_52 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 15) (d := 52) (c := cert_15_52) (by native_decide)
