import Sound
import lean_certs.cert_12_36

open CertVerify

theorem H12_gt_36 : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 36 := by
  exact certValidRoot_sound (k := 12) (d := 36) (c := cert_12_36) (by native_decide)
