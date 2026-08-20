import Sound
import lean_certs.cert_25_62

open CertVerify

theorem H25_gt_62 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 62 := by
  exact certValidRoot_sound (k := 25) (d := 62) (c := cert_25_62) (by native_decide)
