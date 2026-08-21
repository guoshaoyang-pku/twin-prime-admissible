import Sound
import lean_certs.cert_14_40

open CertVerify

theorem H14_gt_40 : ¬ ∃ t : List Nat, admissible 14 t = true ∧ diameter t ≤ 40 := by
  exact certValidRoot_sound (k := 14) (d := 40) (c := cert_14_40) (by native_decide)
