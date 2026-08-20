import Sound
import lean_certs.cert_24_52

open CertVerify

theorem H24_gt_52 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 52 := by
  exact certValidRoot_sound (k := 24) (d := 52) (c := cert_24_52) (by native_decide)
