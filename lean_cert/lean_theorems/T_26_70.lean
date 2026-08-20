import Sound
import lean_certs.cert_26_70

open CertVerify

theorem H26_gt_70 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 70 := by
  exact certValidRoot_sound (k := 26) (d := 70) (c := cert_26_70) (by native_decide)
