import Sound
import lean_certs.cert_35_144

open CertVerify

theorem H35_gt_144 : ¬ ∃ t : List Nat, admissible 35 t = true ∧ diameter t ≤ 144 := by
  exact certValidRoot_sound (k := 35) (d := 144) (c := cert_35_144) (by native_decide)
