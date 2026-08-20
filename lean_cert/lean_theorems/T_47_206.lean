import Sound
import lean_certs.cert_47_206

open CertVerify

theorem H47_gt_206 : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 206 := by
  exact certValidRoot_sound (k := 47) (d := 206) (c := cert_47_206) (by native_decide)
