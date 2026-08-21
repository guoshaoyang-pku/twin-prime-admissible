import Sound
import lean_certs.cert_19_36

open CertVerify

theorem H19_gt_36 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 19) (d := 36) (c := cert_19_36) (by native_decide)
