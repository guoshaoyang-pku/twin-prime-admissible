import Sound
import lean_certs.cert_16_52

open CertVerify

theorem H16_gt_52 : ¬ ∃ t : List Nat, admissible 16 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 16) (d := 52) (c := cert_16_52) (by native_decide)
