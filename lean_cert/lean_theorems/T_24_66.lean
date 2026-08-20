import Sound
import lean_certs.cert_24_66

open CertVerify

theorem H24_gt_66 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 66 := by
  exact certValidRoot_sound (k := 24) (d := 66) (c := cert_24_66) (by native_decide)
