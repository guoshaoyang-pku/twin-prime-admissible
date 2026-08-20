import Sound
import lean_certs.cert_20_52

open CertVerify

theorem H20_gt_52 : ¬ ∃ t : List Nat, admissible 20 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 20) (d := 52) (c := cert_20_52) (by native_decide)
