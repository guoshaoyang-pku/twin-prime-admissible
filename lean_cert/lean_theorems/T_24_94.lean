import Sound
import lean_certs.cert_24_94

open CertVerify

theorem H24_gt_94 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 24) (d := 94) (c := cert_24_94) (by native_decide)
