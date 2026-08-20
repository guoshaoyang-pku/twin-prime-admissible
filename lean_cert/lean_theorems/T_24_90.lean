import Sound
import lean_certs.cert_24_90

open CertVerify

theorem H24_gt_90 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 24) (d := 90) (c := cert_24_90) (by native_decide)
