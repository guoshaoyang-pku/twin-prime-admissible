import Sound
import lean_certs.cert_24_98

open CertVerify

theorem H24_gt_98 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 24) (d := 98) (c := cert_24_98) (by native_decide)
