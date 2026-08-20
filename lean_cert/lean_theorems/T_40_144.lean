import Sound
import lean_certs.cert_40_144

open CertVerify

theorem H40_gt_144 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 40) (d := 144) (c := cert_40_144) (by native_decide)
