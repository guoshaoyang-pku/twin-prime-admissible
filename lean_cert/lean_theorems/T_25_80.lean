import Sound
import lean_certs.cert_25_80

open CertVerify

theorem H25_gt_80 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 25) (d := 80) (c := cert_25_80) (by native_decide)
