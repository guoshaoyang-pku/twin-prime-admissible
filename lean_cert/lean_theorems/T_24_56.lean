import Sound
import lean_certs.cert_24_56

open CertVerify

theorem H24_gt_56 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 24) (d := 56) (c := cert_24_56) (by native_decide)
