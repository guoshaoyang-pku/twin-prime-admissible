import Sound
import lean_certs.cert_40_150

open CertVerify

theorem H40_gt_150 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 150 := by
  exact certValidRoot_sound (k := 40) (d := 150) (c := cert_40_150) (by native_decide)
