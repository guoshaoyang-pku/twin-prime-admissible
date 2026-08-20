import Sound
import lean_certs.cert_40_92

open CertVerify

theorem H40_gt_92 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 92 := by
  exact certValidRoot_sound (k := 40) (d := 92) (c := cert_40_92) (by native_decide)
