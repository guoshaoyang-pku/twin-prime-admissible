import Sound
import lean_certs.cert_24_58

open CertVerify

theorem H24_gt_58 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 24) (d := 58) (c := cert_24_58) (by native_decide)
