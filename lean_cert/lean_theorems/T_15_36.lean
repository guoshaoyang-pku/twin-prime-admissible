import Sound
import lean_certs.cert_15_36

open CertVerify

theorem H15_gt_36 : ¬ ∃ t : List Nat, admissible 15 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 15) (d := 36) (c := cert_15_36) (by native_decide)
