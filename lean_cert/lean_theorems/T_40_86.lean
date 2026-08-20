import Sound
import lean_certs.cert_40_86

open CertVerify

theorem H40_gt_86 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 40) (d := 86) (c := cert_40_86) (by native_decide)
