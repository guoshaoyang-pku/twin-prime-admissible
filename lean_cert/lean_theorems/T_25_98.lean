import Sound
import lean_certs.cert_25_98

open CertVerify

theorem H25_gt_98 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 25) (d := 98) (c := cert_25_98) (by native_decide)
