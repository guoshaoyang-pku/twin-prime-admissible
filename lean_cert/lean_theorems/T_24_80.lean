import Sound
import lean_certs.cert_24_80

open CertVerify

theorem H24_gt_80 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 24) (d := 80) (c := cert_24_80) (by native_decide)
