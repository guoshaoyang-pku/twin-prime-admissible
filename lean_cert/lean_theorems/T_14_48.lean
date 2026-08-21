import Sound
import lean_certs.cert_14_48

open CertVerify

theorem H14_gt_48 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 48 := by
  exact certValidRoot_sound (k := 14) (d := 48) (c := cert_14_48) (by native_decide)
