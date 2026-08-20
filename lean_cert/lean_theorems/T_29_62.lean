import Sound
import lean_certs.cert_29_62

open CertVerify

theorem H29_gt_62 : ¬ ∃ t : List Nat, admissible 29 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 29) (d := 62) (c := cert_29_62) (by native_decide)
