import Sound
import lean_certs.cert_25_56

open CertVerify

theorem H25_gt_56 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 25) (d := 56) (c := cert_25_56) (by native_decide)
