import Sound
import lean_certs.cert_19_56

open CertVerify

theorem H19_gt_56 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 19) (d := 56) (c := cert_19_56) (by native_decide)
