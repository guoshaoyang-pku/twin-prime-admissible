import Sound
import lean_certs.cert_40_168

open CertVerify

theorem H40_gt_168 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 168 := by
  exact certValidRoot_sound (k := 40) (d := 168) (c := cert_40_168) (by native_decide)
