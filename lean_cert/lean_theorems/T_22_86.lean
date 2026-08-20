import Sound
import lean_certs.cert_22_86

open CertVerify

theorem H22_gt_86 : ¬ ∃ t : List Nat, admissible 22 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 22) (d := 86) (c := cert_22_86) (by native_decide)
